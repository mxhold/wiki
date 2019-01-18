class PagesController < ApplicationController
  def home
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    result = CreatePage.call(title: page_params[:title], content: page_params[:content])

    if result.success?
      @page = result.unwrap!
      redirect_to @page, notice: "Page was successfully created."
    else
      @page = result.unwrap_error!
      render :new
    end
  end

  def show
    @page = Page.find_by!(slug: params[:slug])
  end

  private

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
