view: shared_videos {
  sql_table_name: analytics.shared_videos ;;

  dimension: content_partner {
    type: string
    sql: ${TABLE}.contentPartner ;;
  }

  dimension_group: first_playback {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.firstPlaybackDate ;;
  }

  dimension_group: last_playback {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.lastPlaybackDate ;;
  }

  dimension: referer_id {
    type: string
    sql: ${TABLE}.refererId ;;
  }

  dimension: total_seconds_watched {
    type: number
    sql: ${TABLE}.totalSecondsWatched ;;
  }

  dimension: total_hours_watched {
    type:  number
    sql:  ${TABLE}.totalSecondsWatched / 3600 ;;
    value_format_name: "decimal_1"
  }

  dimension: video_id {
    type: string
    sql: ${TABLE}.videoId ;;
  }

  dimension: video_title {
    type: string
    sql: ${TABLE}.videoTitle ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
