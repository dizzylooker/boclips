view: events_sessionized {
  view_label: "Events"

  derived_table: {
#     sql_trigger_value: SELECT CURRENT_DATE() ;;
#     distribution: "event_id"
#     sortkeys: ["created_at"]
    sql:SELECT
      ROW_NUMBER() OVER (ORDER BY log.timestamp) AS event_id
    , log.userid as user_id
    , log.event as event_type
    , log.timestamp as created_at
    , sessions.unique_session_id
    , ROW_NUMBER () OVER (PARTITION BY unique_session_id ORDER BY log.timestamp) AS event_sequence_within_session
    , ROW_NUMBER () OVER (PARTITION BY unique_session_id ORDER BY log.timestamp desc) AS inverse_event_sequence_within_session
FROM ${simple_funnel_events.SQL_TABLE_NAME} AS log
INNER JOIN ${sessions.SQL_TABLE_NAME} AS sessions
  ON log.userid = sessions.user_id
  AND log.timestamp >= sessions.session_start
  AND log.timestamp < sessions.next_session_start
WHERE
  ((CAST(log.timestamp as DATE)) >= (DATE_ADD(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY ))  AND (CAST(log.timestamp as DATE)) < (DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY ), INTERVAL 60 DAY )))
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: event_id {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.event_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: unique_session_id {
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.unique_session_id ;;
  }

  dimension: page_name {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: event_sequence_within_session {
    type: number
    value_format_name: id
    sql: ${TABLE}.event_sequence_within_session ;;
  }

  dimension: inverse_event_sequence_within_session {
    type: number
    value_format_name: id
    sql: ${TABLE}.inverse_event_sequence_within_session ;;
  }

  set: detail {
    fields: [
      event_id,
      #ip_address,
      user_id,
      #os,
      traffic_source,
      #event_time_time,
      unique_session_id,
      event_sequence_within_session,
      inverse_event_sequence_within_session,
      #user_first_session_time,
      #session_landing_page,
      #session_exit_page
    ]
  }
}
