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
    drill_fields: [name, email, organisation_name, user_subject_facts.unnest_subjects_single_subject]
  }
}
