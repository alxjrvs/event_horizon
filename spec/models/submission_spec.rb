require "rails_helper"

describe Submission do
  it { should have_one(:grade).dependent(:destroy) }

  let(:submission) { FactoryGirl.create(:submission) }

  describe "#body=" do
    it "stores the contents as a single file in an archive" do
      submission = FactoryGirl.build(:submission)
      submission.body = "2 + 2 == 5"
      submission.save!

      contents = read_file_from_gzipped_archive(
        submission.archive.path, "file001")
      expect(contents).to eq("2 + 2 == 5")
    end
  end

  describe "comments" do
    let(:source_file) do
      FactoryGirl.create(:source_file, submission: submission)
    end

    let!(:general_comment) do
      FactoryGirl.create(:comment, submission: submission, line_number: nil)
    end

    let!(:inline_comment) do
      FactoryGirl.create(:comment,
        submission: submission,
        line_number: 1,
        source_file: source_file)
    end

    describe "#inline_comments" do
      it "selects comments with line numbers" do
        expect(submission.inline_comments).to include(inline_comment)
        expect(submission.inline_comments).to_not include(general_comment)
      end
    end

    describe "#general_comments" do
      it "selects comments not belonging to source files" do
        expect(submission.general_comments).to include(general_comment)
        expect(submission.general_comments).to_not include(inline_comment)
      end
    end
  end

  describe "#comments_count" do
    it "should be zero, initially" do
      expect(submission.comments_count).to eq(0)
    end

    it "should equal the number of comments" do
      FactoryGirl.create_list(:comment, 5, submission: submission)
      submission.reload
      expect(submission.comments_count).to eq(5)
    end
  end

  describe "#gradable_by?" do

    context "user is admin" do
      let(:admin) { FactoryGirl.create(:admin) }

      context "has not been graded" do
        it "returns true" do
          expect(submission).to be_gradable_by(admin)
        end
      end

      context "has been graded" do
        it "returns false" do
          grade = FactoryGirl.create(:submission_grade)
          expect(grade.submission).to_not be_gradable_by(admin)
        end
      end
    end

    context "user is not admin" do
      it "returns false" do
        user = FactoryGirl.create(:user)

        expect(submission).to_not be_gradable_by(user)
      end
    end

    context "user is guest" do
      it "returns false" do
        expect(submission).to_not be_gradable_by(Guest.new)
      end
    end
  end

  it 'allows an admin to see a grade' do
    admin = FactoryGirl.build(:admin)
    grade = FactoryGirl.create(:submission_grade)
    expect(grade.submission).to be_grade_viewable_by(admin)
  end

  it 'allows the submission author to see a grade' do
    grade = FactoryGirl.create(:submission_grade)
    expect(grade.submission).to be_grade_viewable_by(grade.submission.user)
  end

  it 'does not allow anyone else to see a grade' do
    grade = FactoryGirl.create(:submission_grade)
    expect(grade.submission).to_not be_grade_viewable_by(FactoryGirl.build(:user))
  end
end
