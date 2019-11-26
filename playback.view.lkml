view: playback {
  sql_table_name: analytics.playback ;;
  drill_fields: [playback_id]

  dimension: playback_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.playbackId ;;
  }

  dimension: content_partner {
    type: string
    sql: ${TABLE}.contentPartner ;;
  }

  dimension: duration_seconds {
    type: number
    sql: ${TABLE}.durationSeconds ;;
  }

  dimension: organisation_name {
    type: string
    sql: ${TABLE}.organisationName ;;
  }

  dimension: organisation_type {
    type: string
    sql: ${TABLE}.organisationType ;;
  }

  dimension: parent_organisation_name {
    type: string
    sql: ${TABLE}.parentOrganisationName ;;
  }

  dimension: playback_provider {
    type: string
    sql: ${TABLE}.playbackProvider ;;
  }

  dimension: referer_id {
    type: string
    sql: ${TABLE}.refererId ;;
  }

  dimension: seconds_watched {
    type: number
    sql: ${TABLE}.secondsWatched ;;
  }

#   dimension: subjects {
#     type: string
#     sql: ${TABLE}.subjects ;;
#   } UNNESTED ELSEWHERE

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      hour_of_day,
      week,
      month,
      quarter,
      day_of_week_index,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  dimension_group: since_playback {
    type: duration
    intervals: [hour,day,week,month,quarter,year]
    sql_start: ${TABLE}.timestamp;;
    sql_end: CURRENT_TIMESTAMP()
    ;;
  }

  dimension: url_host {
    type: string
    sql: ${TABLE}.urlHost ;;
  }

  dimension: url_path {
    type: string
    sql: ${TABLE}.urlPath ;;
  }

  dimension: user_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.userId ;;
  }

  dimension: video_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.videoId ;;
  }

  dimension: months_since_signup {
    type: number
    sql: DATE_DIFF(CAST(${timestamp_raw} as DATE),${users.creation_raw},MONTH) ;;
  }

  dimension: is_classroom_time {
    type: yesno
    sql: ${timestamp_hour_of_day} BETWEEN 9 AND 17 ;;
  }

  dimension: is_wtd {
    type: yesno
    sql: ${timestamp_day_of_week_index} < EXTRACT(DAYOFWEEK FROM CURRENT_DATE());;
  }

  dimension: is_share {
    type: yesno
    sql: ${TABLE}.isShare ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_seconds_watched {
    type: sum
    sql: ${seconds_watched} ;;
  }

  measure: total_hours_watched {
    type: sum
    value_format_name: decimal_1
    sql: ${seconds_watched}/3600 ;;
  }

  measure: seconds_watched_per_video {
    type: number
    value_format_name: decimal_2
    sql: ${total_seconds_watched}/NULLIF(${count},0) ;;
  }

  measure: viewer_count {
    type: count_distinct
    sql: ${user_id};;
  }

  measure: referer_count {
    type: count_distinct
    filters: {
      field: referer_id
      value: "-NULL"
    }
    sql: ${referer_id} ;;
  }

  measure: classroom_view_count {
    type: count
    filters: {
      field: is_classroom_time
      value: "yes"
    }
  }

  measure: classroom_view_pct {
    type: number
    value_format_name: percent_2
    sql: 1.00*(${classroom_view_count}/NULLIF(${count},0)) ;;
  }

  measure: viewer_count_30d {
    type: count_distinct
    sql: ${user_id};;
    filters: {
      field: timestamp_date
      value: "last 30 days"
    }
  }

  measure: shared_count {
    type: count
    filters: {
      field: is_share
      value: "yes"
    }
  }

  measure: pct_shared {
    type: number
    value_format_name: percent_2
    sql: 1.00*(${shared_count}/NULLIF(${count},0)) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      unnest_subjects.single_subject,
      videos.title,
      viewer_count,
      total_seconds_watched
    ]
  }
}
