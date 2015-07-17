class NotesController < ApplicationController

  def new
    @note = Note.new
  end

  def create
    @student = Student.find(params[:student_id])
    @note = @student.notes.build(note_params)

    if @note.save
      flash.now[:success] = "Note successfully added"
    else
      flash.now[:error] = @note.errors.full_messages.join("<br/>").html_safe
    end
  end

  private

  def note_params
    params.require(:note).permit(:date, :title, :body)
  end
end
