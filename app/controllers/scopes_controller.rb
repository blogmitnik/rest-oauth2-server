class ScopesController < ApplicationController
 
  before_filter :find_resource, only: ["show", "update", "destroy"]

  def index
    @scopes = Scope.all.paginate page: params[:page], per_page: params[:per_page]
  end

  def show
  end

  def new
    @scope = Scope.new
  end

  def create
    @scope        = Scope.new(params[:scope])
    @scope.uri    = @scope.base_uri(request)
    @scope.values = @scope.normalize(params[:scope][:values])

    if @scope.save
      redirect_to(@scope, notice: 'Resource was successfully created.')
    else
      render action: "new"
    end
  end

  def update
    if @scope.update_attributes(@body)
      render "show", status: 200, location: @scope.uri
    else
      render_422 "notifications.document.not_valid", @scope.errors
    end
  end

  def destroy
    @scope.destroy
    head 204
  end


  private

    def find_resource
      @scope = Scope.criteria.id(params[:id]).first
      resource_not_found unless @scope
    end

    def resource_not_found
      flash.now.alert = "notifications.document.not_found"
      @info = { id: params[:id] }
      render "shared/html/404" and return
    end

end
