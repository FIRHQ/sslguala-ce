class Api::V1::ApiTokensController < ApiController  
  skip_before_action :auth_user!
  before_action :auth_api_token!
  before_action :valid, only: [:create_domain]

  def check_domains
    @check_domains = current_user.check_domains.includes(:msg_channels)
    render "api/v1/check_domains/index"
  end

  def create_domain
    @project = current_user.projects.find_by(id: check_domain_params[:project_id])
    @channel = current_user.msg_channels.find_by(id: params[:channel_id])
    @check_domain = current_user.check_domains.new(check_domain_params)
    @check_domain.project_id = @project&.id
    if @check_domain.save
      @channel.bind_domain(@check_domain.id) if @channel.present?
      render "api/v1/check_domains/show"
    else
      render json: @check_domain.errors, status: 422
    end
  rescue => e
    render json: { error: e }, status: 422
  end

  def destroy_domain
    @check_domain = current_user.check_domains.find_by(id: params[:id])
    if @check_domain.destroy
      render json: {status: 'ok'}
    else
      render json: {error: @check_domain.errors}, status: 422
    end    
  end

  def valid
    domain = params[:domain]
    domain = CheckDomain.parse_domain(domain)

    return render json: {error: "请填写正确的域名地址" }, status: 422 if domain.blank?

    answer = CheckDomain.ask_expire_time(domain)
    render json: { expire_at: answer}
  rescue StandardError => e
    render json: { error: e }, status: 422
  end

  def msg_channels
    @msg_channels = current_user.msg_channels
    render "api/v1/msg_channels/index"
  end

  def projects
    @projects = current_user.projects
    render "api/v1/projects/index"
  end

  protected

  def set_check_domain
    @check_domain = current_user.check_domains.find params[:id]
  end

  def check_domain_params
    params.permit(:domain, :markup, :project_id)
  end

  def auth_api_token!
    api_token = params[:api_token]
    if api_token.present? && user = User.find_by(api_token: api_token)
       @current_user = user
    else
      render json: { error: 'please check your api token'}, status: 401
    end
  end

  def valid
    domain = params[:domain]
    domain = CheckDomain.parse_domain(domain)

    return render json: {error: "请填写正确的域名地址"}, status: 422 if domain.blank?

    answer = CheckDomain.ask_expire_time(domain)
  rescue StandardError => e
    render json: { error: e }, status: 422
  end
end
