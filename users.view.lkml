view: users {
  sql_table_name: analytics.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: creation {
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
    sql: ${TABLE}.creationDate ;;
  }

  dimension: organisation_name_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.organisationName ;;
  }

  dimension: organisation_name {
    type: string
    sql: CASE WHEN '{{_user_attributes["can_see_ppi"]}}' = 'yes' THEN ${organisation_name_raw}
         ELSE CAST(MD5(${organisation_name_raw}) as STRING)
         END;;
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

  dimension: parent_organisation_name {
    type: string
    sql: ${TABLE}.parentOrganisationName ;;
  }

  measure: count {
    type: count
    drill_fields: [organisation_name, user_subject_facts.unnest_subjects_single_subject, count]
  }
}
