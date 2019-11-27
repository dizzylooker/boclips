
view: ordered_videos {
  derived_table: {
    sql: select id as orderId, videoId from orders cross join unnest(videoIds) as videoId ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.orderId ;;
  }

  dimension: video_id {
    type: string
    sql: ${TABLE}.videoId ;;
  }

  measure: count {
    type: count
    drill_fields: [video_id]
  }

  measure: count_unique_videos {
    type: count_distinct
    sql: ${video_id} ;;
  }
}
