class Api::V1::ProjectsController < ApiController
  before_action :set_project, only: %i[update show destroy add_domains]
  def index
    @projects = current_user.projects.order("created_at desc")
  end

  def add_domains
    domain_ids = params[:domain_ids]
    current_user.check_domains.where(id: domain_ids).each do |domain|
      domain.update(project_id: @project.id)
    end
    render :show

  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      render
    else
      render json: @project.errors, status: 422
    end
  end

  def show
  end

  def update
    if @project.update(project_params)
      render
    else
      render json: @project.errors, status: 422
    end
  end

  def destroy
    if @project.destroy
      head 200
    else
      render json: @project.errors, status: 422
    end
  end

  protected

  def project_params
    params.permit(:name, :description)

  end

  def set_project
    @project = current_user.projects.find params[:id]
  end
end
