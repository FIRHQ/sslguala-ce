require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Wechat < OmniAuth::Strategies::OAuth2
      option :name, "wechat"
      option :full_host

      option :client_options, {
          site:          "https://api.weixin.qq.com",
          authorize_url: "https://open.weixin.qq.com/connect/qrconnect?#wechat_redirect",
          token_url:     "/sns/oauth2/access_token",
          token_method:  :get
      }

      option :authorize_params, {scope: "snsapi_login"}

      option :token_params, {parse: :json}

      def callback_url
        (options[:full_host].presence || full_host) + script_name + callback_path
      end

      uid do
        raw_info['openid']
      end

      info do
        {
            nickname:   raw_info['nickname'],
            sex:        raw_info['sex'],
            province:   raw_info['province'],
            city:       raw_info['city'],
            country:    raw_info['country'],
            headimgurl: raw_info['headimgurl'],
            image:      raw_info['headimgurl'],
            unionid:    raw_info['unionid']
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def request_phase
        params = client.auth_code.authorize_params.merge(authorize_params)
        params["appid"] = params.delete("client_id")
        params["redirect_uri"] = callback_url
        redirect client.authorize_url(params)
      end

      def raw_info
        @uid ||= access_token["openid"]
        @raw_info ||= begin
          access_token.options[:mode] = :query
          if access_token["scope"]&.include?("snsapi_login")
            access_token.get("/sns/userinfo", :params => { "openid" => @uid, "lang" => "zh_CN" }, parse: :json).parsed
          else
            { "openid" => @uid }
          end
        end
        @raw_info
      end

      protected
      def build_access_token
        params = {
            'appid'        => client.id,
            'secret'       => client.secret,
            'code'         => request.params['code'],
            'grant_type'   => 'authorization_code',
            'redirect_uri' => callback_url
        }.merge(token_params.to_hash(symbolize_keys: true))
        client.get_token(params, deep_symbolize(options.auth_token_params))
      end

    end
  end
end
