view: user_subject_facts {
  derived_table: {
    sql: SELECT
      playback_user_id,
      unnest_subjects_single_subject
      FROM (
      SELECT
        playback.userId  AS playback_user_id,
      --   playback.timestamp as time,
        single_subject  AS unnest_subjects_single_subject,
        RANK() OVER(PARTITION BY playback.userId ORDER BY COUNT(*) DESC) as order_rank
      FROM analytics.playback  AS playback
      LEFT JOIN UNNEST(playback.subjects) as single_subject
      GROUP BY 1,2
      )
      WHERE order_rank = 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: playback_user_id {
    type: string
    sql: ${TABLE}.playback_user_id ;;
  }

  dimension: unnest_subjects_single_subject {
    label: "Teacher Subject"
    type: string
    sql: ${TABLE}.unnest_subjects_single_subject ;;
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${playback_user_id}, ${unnest_subjects_single_subject}) ;;
  }

  set: detail {
    fields: [playback_user_id, unnest_subjects_single_subject]
  }
}
