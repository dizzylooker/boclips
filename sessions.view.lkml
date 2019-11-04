view: sessions {
  derived_table: {
    sql:
      WITH lag AS
              (SELECT
                        logs.timestamp AS created_at
                      , logs.userid AS user_id
                      , TIMESTAMP_DIFF(
                          logs.timestamp
                        , LAG(logs.timestamp) OVER ( PARTITION BY logs.userid ORDER BY logs.timestamp)
                        , MINUTE) AS idle_time
                    FROM ${simple_funnel_events.SQL_TABLE_NAME} as logs
                    WHERE ((CAST(logs.timestamp as DATE)) >= (DATE_ADD(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY))
                          AND (CAST(logs.timestamp as DATE)) < (DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY ), INTERVAL 60 DAY ))) -- optional limit of events table to only past 60 days
                    )
              SELECT
                lag.created_at AS session_start
                , lag.idle_time AS idle_time
                , lag.user_id AS user_id
                , ROW_NUMBER () OVER (ORDER BY lag.created_at) AS unique_session_id
                , ROW_NUMBER () OVER (PARTITION BY lag.user_id ORDER BY lag.created_at) AS session_sequence
                , COALESCE(
                      LEAD(lag.created_at) OVER (PARTITION BY lag.user_id ORDER BY lag.created_at)
                    , '6000-01-01') AS next_session_start
              FROM lag
              WHERE (lag.idle_time > 60 OR lag.idle_time IS NULL)  -- session threshold (currently set at 60 minutes)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension: idle_time {
    type: number
    sql: ${TABLE}.idle_time ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: unique_session_id {
    type: number
    sql: ${TABLE}.unique_session_id ;;
  }

  dimension: session_sequence {
    type: number
    sql: ${TABLE}.session_sequence ;;
  }

  dimension_group: next_session_start {
    type: time
    sql: ${TABLE}.next_session_start ;;
  }

  set: detail {
    fields: [
      session_start_time,
      idle_time,
      user_id,
      unique_session_id,
      session_sequence,
      next_session_start_time
    ]
  }
}
