json.call(check_domain, :id, :domain, :expire_at, :created_at, :updated_at, :project_id, :check_expire_time_at,
          :remain_days)
json.msg_channels do
  json.array! check_domain.msg_channels.order('id asc'), :id, :title, :type
end
