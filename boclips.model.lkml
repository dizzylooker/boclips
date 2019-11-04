connection: "bigquery"

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

# Explores

explore: playback {
  join: videos {
    relationship: many_to_one
    sql_on: ${playback.video_id} = ${videos.id} ;;
  }
  join: unnest_subjects {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(playback.subjects) as single_subject ;;
  }
  # join: ages { DISALLOWED?
  #   relationship: one_to_many
  #   sql: LEFT JOIN UNNEST(ages) as age ;;
  # }
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
}

explore: search {
  join: user_subject_facts {
    relationship: many_to_many
    sql_on: ${search.user_id} = ${user_subject_facts.playback_user_id} ;;
  }
}

explore: simple_funnel_events {}

# Views for unnest

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
}
