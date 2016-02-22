class RemoveSurveyAndAnswers < ActiveRecord::Migration
  def change
    drop_table :surveys
    drop_table :answers
    drop_table :questions
    drop_table :user_surveys
  end
end
