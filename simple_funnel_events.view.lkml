view: simple_funnel_events {
  derived_table: {
    sql: SELECT timestamp, userid, 'Search' as event FROM `boclips-prod.analytics.search`
      UNION ALL
      SELECT timestamp, userid, 'Playback' as event FROM `boclips-prod.analytics.playback`
       ;;
#     sql_trigger_value: SELECT CURRENT_DATE() ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}.userid ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  set: detail {
    fields: [timestamp_time, userid, event]
  }
}
