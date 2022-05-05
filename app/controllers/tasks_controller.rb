class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @project = Project.find(params[:project_id])
    @tasks = Task.where(project_id: params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
  end

  def create
    @project = Project.find(params[:project_id])
    executor = User.find_by(id: task_params[:executor])
    @task = @project.tasks.build(task_params.merge(author: current_user, executor: executor))

    if @task.save
      redirect_to project_path @project
    else
      redirect_to projects_path, alert: "error"
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    executor = User.find_by(id: task_params[:executor])
    @task = Task.find(params[:id])
    if @task.update task_params.merge(executor: executor)
      redirect_to project_path @project
    else
      redirect_to projects_path, alert: "error"
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    if @task.disabled
      flash[:success] = "ok"
    else
      flash[:alert] = "bad"
    end
    redirect_to project_path @project
  end

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
  end

  def move
    task = Task.find(params[:id])
    task.update task_move_params
  end

  private

  def task_params
    params.require(:task).permit(:title, :describle, :project_id, :status, :executor)
  end

  def task_move_params
    params.permit(:status, :position)
  end
end
