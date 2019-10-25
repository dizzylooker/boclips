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

  dimension: video_seconds_played {
    type: number
    sql: ${TABLE}.videoSecondsPlayed ;;
  }

  dimension: videos_played {
    type: number
    sql: ${TABLE}.videosPlayed ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
