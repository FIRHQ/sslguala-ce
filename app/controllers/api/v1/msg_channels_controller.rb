class Api::V1::MsgChannelsController < ApiController
  before_action :set_channel, only: %i[update show destroy bind unbind try_send_message multiple_bind]
  def index
    @msg_channels = current_user.msg_channels
    if params[:domain_id]
      domain = current_user.check_domains.find_by_id params[:domain_id]
      return if domain.nil?

      @msg_channels = domain.msg_channels
    end

    @msg_channels = @msg_channels.where(is_common: true) if params[:is_common].to_s == 'true'
  end

  def multiple_bind
    domain_ids = current_user.check_domains.where(id: params[:domain_ids]).pluck(:id)
    domain_ids.each do |domain_id|
      @msg_channel.bind_domain(domain_id)
    end
    render json: {msg: 'ok'}
  end

  def bind
    if @msg_channel.bind_domain(params[:domain_id])
      render :show
    else
      render json: { msg: 'domain_id not found' }, status: 400
    end
  end

  def unbind
    if @msg_channel.unbind_domain(params[:domain_id])
      render :show
    else
      render json: { msg: 'domain_id not found' }, status: 400
    end
  end

  def create
    @msg_channel = current_user.msg_channels.new(msg_channel_params)
    if @msg_channel.save
      @msg_channel.bind_domain(params[:domain_id]) if params[:domain_id]
      render :show
    else
      render json: @msg_channel.errors, status: 422
    end
  end

  def try_send_message
    domain_id = params[:domain_id]
    if domain_id.present? && check_domain = current_user.check_domains.find_by(id: domain_id)
      title = "sslguala通知-#{check_domain.domain}"
      body = "#{check_domain.domain} 的SSL证书的过期时间为 #{check_domain.expire_at}."
      answer = @msg_channel.send_msg(title, body)
    else
      title = "sslguala通知"
      body = "感谢使用sslguala,您能正常接收到通知"
      answer = @msg_channel.send_msg(title, body)
    end
    render json: answer
  end

  def show
    render
  end

  def update
    if @msg_channel.update(msg_channel_params)
      render :show
    else
      render json: @msg_channel.errors, status: 422
    end
  end

  def destroy
    if @msg_channel.domain_msg_channels.map{ |x| x.destroy } && @msg_channel.destroy
      render json: {status: "success" }
    else
      render json: @msg_channel.errors, status: 422
    end
  end

  private

  def msg_channel_params
    params.permit(:title, :url, :type, :is_default, :markup, :is_common, :config_secret, :config_custom_string, :config_email)
  end

  def set_channel
    @msg_channel = current_user.msg_channels.find params[:id]
  end
end
