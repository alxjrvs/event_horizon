class LessonsController < ApplicationController
  def index
    @active_type = params[:type]
    @order = params[:order]
    @lessons = filter_lessons(ordered_lessons)
  end

  def show
    @lesson = Lesson.find_by!(slug: params[:slug])
    @rating = @lesson.ratings.find_or_initialize_by(user: current_user)
  end

  private

  def ordered_lessons
    if params[:order] == "most_recent"
      Lesson.order(created_at: :desc)
    else
      Lesson.order(:title)
    end
  end

  def filter_lessons(lessons)
    lessons = visible_filter(current_user, lessons)
    lessons = type_filter(params[:type], lessons)
    lessons = submittable_filter(params[:submittable], lessons)
    lessons
  end

  def submittable_filter(flag, lessons)
    if flag == "1"
      lessons.submittable
    else
      lessons
    end
  end

  def type_filter(type, lessons)
    if type
      lessons.type(type)
    else
      lessons
    end
  end

  def visible_filter(user, lessons)
    if user
      lessons.visible_for(user)
    else
      lessons.public
    end
  end
end
