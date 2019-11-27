view: videos {
  sql_table_name: analytics.videos ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: ages {
    type: string
    sql: ${TABLE}.ages ;;
  }

  dimension: content_partner {
    type: string
    sql: ${TABLE}.contentPartner ;;
  }

  dimension: playback_provider {
    type: string
    sql: ${TABLE}.playbackProvider ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [title, playback.count]
  }

  measure: content_partner_count_distinct {
    type: count_distinct
    sql: ${content_partner} ;;
  }
}
