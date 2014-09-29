require "rails_helper"

describe LessonsController do
  context "api" do
    render_views

    describe "GET index" do
      it "lists just the lesson name and slug" do
        lessons = FactoryGirl.create_list(:lesson, 3)

        get :index, format: :json
        result = JSON.parse(response.body)

        lessons.each do |lesson|
          lesson_info = {
            "title" => lesson.title,
            "slug" => lesson.slug
          }

          expect(result["lessons"]).to include(lesson_info)
        end
      end
    end

    describe "GET show" do
      it "includes the lesson details" do
        lesson = FactoryGirl.create(:lesson)

        get :show, slug: lesson.slug, format: :json
        result = JSON.parse(response.body)

        expect(result["lesson"]["title"]).to eq(lesson.title)
        expect(result["lesson"]["body"]).to eq(lesson.body)
        expect(result["lesson"]["archive_url"]).to eq(lesson.archive.url)
      end
    end
  end
end
