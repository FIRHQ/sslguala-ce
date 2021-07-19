json.call(msg_channel, :id, :is_default, :title, :url, :config_email, :type, :markup, :is_common, :config_secret, :config_custom_string)

json.chechk_domains do
  json.array! msg_channel.check_domains, :id, :domain
end
