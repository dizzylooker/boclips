view: collections {
  sql_table_name: analytics.collections ;;
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

  dimension: bookmarks {
    type: string
    sql: ${TABLE}.bookmarks ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.createdAt ;;
  }

  dimension: deleted {
    type: yesno
    sql: ${TABLE}.deleted ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.ownerId ;;
  }

  dimension: public {
    type: yesno
    sql: ${TABLE}.public ;;
  }

  dimension: subjects {
    type: string
    sql: ${TABLE}.subjects ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updatedAt ;;
  }

  dimension: video_ids {
    type: string
    sql: ${TABLE}.videoIds ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
