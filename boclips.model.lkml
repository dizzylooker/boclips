connection: "bigquery"

include: "*.view.lkml"

explore: playback {
  join: videos {
    relationship: many_to_one
    sql_on: ${playback.video_id} = ${videos.id} ;;
  }
  join: unnest_subjects {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(playback.subjects) as single_subject ;;
  }
  join: users {
    type: full_outer
    relationship: many_to_one
    sql_on: ${playback.user_id} = ${users.id} ;;
  }
  join: user_subject_facts {
    relationship: many_to_many
    sql_on: ${playback.user_id} = ${user_subject_facts.playback_user_id} ;;
  }
  join: retention_30d {
    from: playback
    fields: []
    relationship: one_to_many
    sql_on: ${users.id} = ${retention_30d.user_id} AND
      (((${retention_30d.timestamp_raw} ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY))) AND (${retention_30d.timestamp_raw} ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY))))) ;;
  }
}

explore: users {
  join: user_subject_facts {
    relationship: many_to_many
    sql_on: ${users.id} = ${user_subject_facts.playback_user_id} ;;
  }
  join: retention_30d {
    from: playback
    fields: []
    relationship: one_to_many
    sql_on: ${users.id} = ${retention_30d.user_id} AND
    (((${retention_30d.timestamp_raw} ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY))) AND (${retention_30d.timestamp_raw} ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY))))) ;;
  }

  join: user_search_facts {
    relationship: one_to_one
    sql_on: ${user_search_facts.userId} = ${users.id};;
  }

  join: search{
    relationship: many_to_one
    sql_on: ${search.user_id} = ${users.id} ;;
  }
}

explore: search {
  join: user_subject_facts {
    relationship: many_to_many
    sql_on: ${search.user_id} = ${user_subject_facts.playback_user_id} ;;
  }

  join: user_search_facts {
    relationship: many_to_one
    sql_on: ${search.user_id} = ${user_search_facts.userId} ;;
  }
}

explore: simple_funnel_events {}

explore: events_sessionized {

  join: sessions {
    relationship: many_to_one
    type: left_outer
    sql_on: ${events_sessionized.unique_session_id} = ${sessions.unique_session_id} ;;
  }

  join: session_facts {
    relationship: many_to_one
    type: inner
    view_label: "Sessions"
    sql_on: ${sessions.unique_session_id} = ${session_facts.unique_session_id} ;;
  }

  join: simple_funnel_events {
    relationship: one_to_one
    sql_on: ${events_sessionized.timestamp_raw} = ${simple_funnel_events.timestamp_raw}
    AND ${events_sessionized.user_id} = ${simple_funnel_events.userid};;
  }
}

explore: funnel_explorer {

  always_filter: {
    filters: {
      field: event_time
      value: "30 days"
    }
  }
}


explore: collections {
  join: users {
    relationship: many_to_one
    sql_on: ${collections.owner_id} = ${users.id} ;;
  }
  join: retention_30d {
    from: playback
    fields: []
    relationship: one_to_many
    sql_on: ${users.id} = ${retention_30d.user_id} AND
      (((${retention_30d.timestamp_raw} ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY))) AND (${retention_30d.timestamp_raw} ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY))))) ;;
  }
  join: unnest_subjects {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(collections.subjects) as single_subject ;;

}
  join: unnest_video_ids {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(${collections.video_ids}) as single_video_id;;
  }
}

explore: orders {
  view_name: ordered_videos
  join: videos {
    relationship: many_to_one
    sql_on: ${ordered_videos.video_id} = ${videos.id} ;;
  }
  join: orders {
    relationship: many_to_one
    sql_on: ${ordered_videos.order_id} = ${orders.id} ;;
  }
}
