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

  dimension: subjects {
    type: string
    sql: ${TABLE}.subjects ;;
  }

  measure: count {
    type: count
    drill_fields: [id, playback.count]
  }
}
