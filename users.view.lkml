view: users {
  sql_table_name: analytics.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: is_mtd {
    type: yesno
    sql: ${creation_day_of_month} < EXTRACT(DAY FROM CURRENT_DATE());;
  }

  dimension_group: creation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      day_of_month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.creationDate ;;
  }

  dimension: first_name_raw {
    hidden: yes
    type:  string
    sql:  ${TABLE}.firstName ;;
  }

  dimension: last_name_raw {
    hidden: yes
    type:  string
    sql:  ${TABLE}.lastName ;;
  }

  dimension: name {
    type: string
    sql: CASE WHEN '{{_user_attributes["can_see_ppi"]}}' = 'yes' THEN CONCAT(${first_name_raw}," ",${last_name_raw})
         ELSE 'Hidden'
         END;;
  }

  dimension: email_raw {
    hidden:  yes
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: email {
    type: string
    sql: CASE WHEN '{{_user_attributes["can_see_ppi"]}}' = 'yes' THEN ${email_raw}
         ELSE 'Hidden'
         END;;
  }

  dimension: organisation_name {
    type: string
    sql: ${TABLE}.organisationName ;;
  }

  dimension: is_retained_30d {
    type: yesno
    sql: ${retention_30d.user_id} IS NOT NULL;;
  }

  dimension: organisation_type {
    type: string
    sql: ${TABLE}.organisationType ;;
  }

  dimension: postcode {
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.organisationPostcode ;;
  }

  dimension: subjects {
    type: string
    sql: ARRAY_TO_STRING(${TABLE}.subjects , ", ", "/") ;;
  }

  dimension: parent_organisation_name {
    type: string
    sql: ${TABLE}.parentOrganisationName ;;
  }

  measure: count {
    type: count
    drill_fields: [name, email, parent_organisation_name, organisation_name, subjects]
  }

  measure: count_retained_30d {
    hidden: yes
    type: count
    filters: {
      field: is_retained_30d
      value: "yes"
    }
  }

  measure: 30d_retention_pct {
    type: number
    value_format_name: percent_2
    sql: 1.00*(${count_retained_30d}/NULLIF(${count},0)) ;;
  }
}
