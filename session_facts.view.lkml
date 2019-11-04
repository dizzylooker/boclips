view: session_facts {
  derived_table: {
#     sql_trigger_value: SELECT CURRENT_DATE() ;;
#     distribution: "unique_session_id"
#     sortkeys: ["session_start"]
    sql: WITH session_facts AS
        (
          SELECT
             unique_session_id
            , logs_with_session_info.created_at
            , user_id
            , event_id
            , event_type
            , COALESCE(user_id) as identifier
            , FIRST_VALUE (created_at) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_start
            , LAST_VALUE (created_at) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_end
            , FIRST_VALUE (event_type) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_landing_page
            , LAST_VALUE  (event_type) OVER (PARTITION BY unique_session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_exit_page
          FROM
              ${events_sessionized.SQL_TABLE_NAME} AS logs_with_session_info
          GROUP BY 1,2,3,4,5,6
          ORDER BY unique_session_id asc
        )
      SELECT
        session_facts.unique_session_id
        , session_facts.identifier
        , session_facts.session_start
        , session_facts.session_end
        , session_landing_page
        , session_exit_page
        , ROW_NUMBER () OVER (PARTITION BY session_facts.identifier ORDER BY MIN(session_start)) AS session_sequence_for_user
        , ROW_NUMBER () OVER (PARTITION BY session_facts.identifier ORDER BY MIN(session_start) desc) AS inverse_session_sequence_for_user
        , count(1) as events_in_session
      FROM session_facts
      INNER JOIN
        ${events_sessionized.SQL_TABLE_NAME} AS logs_with_session_info
      ON
        logs_with_session_info.created_at = session_facts.session_start
        AND logs_with_session_info.unique_session_id = session_facts.unique_session_id
      GROUP BY 1,2,3,4,5,6
      ORDER BY session_start asc
       ;;
  }

  dimension: unique_session_id {
    hidden: yes
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.unique_session_id ;;
  }

  dimension_group: session_start_at {
    type: time
    convert_tz: no
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end_at {
    type: time
    convert_tz: no
    timeframes: [time, date, week, month]
    sql: ${TABLE}.session_end ;;
  }

  dimension: session_sequence_for_user {
    type: number
    sql: ${TABLE}.session_sequence_for_user ;;
  }

  dimension: inverse_session_sequence_for_user {
    type: number
    sql: ${TABLE}.inverse_session_sequence_for_user ;;
  }

  dimension: number_of_events_in_session {
    type: number
    sql: ${TABLE}.events_in_session ;;
  }

  dimension: session_landing_page {
    type: string
    sql: ${TABLE}.session_landing_page ;;
  }

  dimension: session_exit_page {
    type: string
    sql: ${TABLE}.session_exit_page ;;
  }

  dimension: session_length_seconds {
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.session_end, ${TABLE}.session_start, SECOND) ;;
  }

  dimension: session_length_seconds_tier {
    type: tier
    tiers: [
      0,
      15,
      30,
      45,
      60,
      75,
      100
    ]
    sql: ${session_length_seconds} ;;
  }

  measure: average_session_length_seconds {
    type: average
    sql: ${session_length_seconds} ;;
  }

  measure: session_facts_count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      unique_session_id,
      session_start_at_time,
      session_end_at_time,
      session_sequence_for_user,
      inverse_session_sequence_for_user,
      number_of_events_in_session,
      session_landing_page,
      session_exit_page
    ]
  }
}
