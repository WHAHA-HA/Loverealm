class Admin::MentorsController < ApplicationController
  before_action :set_admin_mentor, only: [:show, :edit, :update, :destroy]
  before_filter :allow_most_one_topic, only: [:update]

  # GET /admin/mentors
  # GET /admin/mentors.json
  def index
    @mentors = User.all_mentors.page(params[:page]).per(10)
  end

  # GET /admin/mentors/1
  # GET /admin/mentors/1.json
  def show
    @mentoring_hash_tag = @mentor.mentorship_hash_tag.try(:name)
  end

  # PATCH/PUT /admin/mentors/1
  # PATCH/PUT /admin/mentors/1.json
  def update
    tag = HashTag.find_by_name(params[:tags])
    @mentor.mentorship_hash_tag = tag
    respond_to do |format|
      if @mentor.save
        format.html { redirect_to admin_mentors_path, notice: 'Mentor was successfully updated.' }
        format.json { render :show, status: :ok, location: @mentor }
      else
        format.html { render :edit }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/mentors/1
  # DELETE /admin/mentors/1.json
  def destroy
    @mentor.role = Role.find_by_name('users')
    if @mentor.save
      redirect_to :back, notice: 'Mentor was successfully removed.'
    else
      redirect_to :back, notice: 'Something went wrong.'
    end
  end

  private

  def allow_most_one_topic
    selected_tags = params[:tags].split(',')
    unless selected_tags.size == 1
      redirect_to :back, flash: { error: 'Choose only 1 topic' }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_mentor
    @mentor = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_mentor_params
    params[:admin_mentor]
  end
end
