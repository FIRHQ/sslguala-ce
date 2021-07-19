class Api::V1::CheckDomainsController < ApiController
  before_action :set_check_domain, only: %i[show destroy check_now update]
  skip_before_action :auth_user!, only: [:welcome]
  def index
    @check_domains = current_user.check_domains.ransack(params.permit(:project_id_eq, :expire_at_gteq, :expire_at_lt,
                                                                      :domain_cont, :project_id_null)).result
    @check_domains = @check_domains.includes(:msg_channels)

    order_dict = if params[:order_name].blank?
                   { 'created_at' => 'desc' }
                 else
                   { params[:order_name] => params[:order_desc].to_s == 'true' ? 'desc' : 'asc' }
                 end

    Rails.logger.info order_dict
    Rails.logger.info @check_domains.order(order_dict).to_sql
    pagy, @check_domains = pagy(@check_domains.order(order_dict))
    pagy_headers_merge(pagy)
  end

  def welcome
    render json: { msg: 'ok' }
  end

  def batch_create
    info = CheckDomain.batch_create(current_user, params[:domains], params[:project_id], params[:markup])

    render json: {
      new_domains: info[:new_domains].map { |domain| { id: domain.id, domain: domain.domain } }
    }
  end

  def create
    @check_domain = current_user.check_domains.new(check_domain_params)
    if @check_domain.save
      render
    else
      render json: @check_domain.errors, status: 422
    end
  rescue StandardError => e
    render json: { error: e }, status: 422
  end

  def show
    render
  end

  def check_now
    @check_domain.update_check_expire_time
    render :show
  end

  def update
    if @check_domain.update(check_domain_params)
      render
    else
      render json: @check_domain.errors, status: 422
    end
  end

  def destroy
    @check_domain.destroy
    head 200
  end

  def valid
    domain = params[:domain]
    domain = CheckDomain.parse_domain(domain)

    return render json: { error: '请填写正确的域名地址' }, status: 422 if domain.blank?

    answer = CheckDomain.ask_expire_time(domain)
    render json: { expire_at: answer }
  rescue StandardError => e
    render json: { error: e }, status: 422
  end

  protected

  def set_check_domain
    @check_domain = current_user.check_domains.find params[:id]
  end

  def check_domain_params
    params.permit(:domain, :markup, :project_id)
  end
end
