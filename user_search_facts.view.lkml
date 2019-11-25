view: user_search_facts {
  derived_table: {
  sql:
    select
      userId,
      MAX(timestamp)  AS last_search_timestamp
    from search
    group by userId
;;
}
dimension:  userId {
  type: string
  sql: ${TABLE}.userId
;;
}

dimension: last_search_timestamp {
  type: date_time
  sql: ${TABLE}.last_search_timestamp;;
}

dimension: days_since_last_search {
  type:  number
  sql: DATE_DIFF(CURRENT_DATE(), DATE(${TABLE}.last_search_timestamp), DAY) ;;
}
}
