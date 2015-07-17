class NotesController < ApplicationController
  before_action :find_student
  
  def new
    @note = Note.new
  end

  def create
    @note = @student.notes.build(note_params)
  end

  private

  def find_student
    @student = Student.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:date, :body)
  end
end
