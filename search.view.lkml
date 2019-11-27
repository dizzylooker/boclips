view: search {
  sql_table_name: analytics.search ;;

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: result_pages_seen {
    type: number
    sql: ${TABLE}.resultPagesSeen ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.userId ;;
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${timestamp_raw} AS STRING),${user_id}) ;;
  }

  dimension: video_seconds_played {
    type: number
    sql: ${TABLE}.videoSecondsPlayed ;;
  }

  dimension: videos_played {
    type: number
    sql: ${TABLE}.videosPlayed ;;
  }

  dimension_group: since_search {
    type: duration
    intervals: [hour,day,week,month,quarter,year]
    sql_start: ${TABLE}.timestamp;;
    sql_end: CURRENT_TIMESTAMP()
      ;;
  }

  dimension: search_30_days_active {
    type:  yesno
    sql:  ${days_since_search}<=30 ;;

  }

  measure: count_users_30d_search_active {
    type:  count_distinct
    filters: {
      field:  search_30_days_active
      value: "yes"
    }
    sql: ${user_id} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
