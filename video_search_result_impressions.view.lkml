view: video_search_result_impressions {
  sql_table_name: analytics.video_search_result_impressions ;;

  dimension: content_partner {
    type: string
    sql: ${TABLE}.contentPartner ;;
  }

  dimension: interaction {
    type: yesno
    sql: ${TABLE}.interaction ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
