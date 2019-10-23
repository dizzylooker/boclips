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

  dimension: subjects {
    type: string
    sql: ${TABLE}.subjects ;;
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

  measure: count {
    type: count
#     filters: {
#       field: seconds_watched
#       value: "> 5"
#     }
    drill_fields: [detail*]
  }

  measure: total_seconds_watched {
    type: sum
    sql: ${seconds_watched} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      playback_id,
      parent_organisation_name,
      organisation_name,
      videos.id,
      users.organisation_name,
      users.parent_organisation_name,
      users.id
    ]
  }
}
