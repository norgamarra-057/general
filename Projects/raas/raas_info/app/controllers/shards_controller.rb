class ShardsController < ApplicationController
  before_action :set_shard, only: [:show, :edit, :update, :destroy]

  # GET /shards
  # GET /shards.json
  def index
    if params[:db_id]
      @shards = Shard.includes(:db, :node).where(db_id: params[:db_id])
    elsif params[:cluster_id]
      dbs = Db.where(cluster_id: params[:cluster_id])
      @shards = Shard.includes(:db, :node).where(db_id: dbs)
    elsif params[:node_id]
      @shards = Shard.includes(:db, :node).where(node_id: params[:node_id])
    else
      @shards = Shard.includes(:db, :node)
    end
  end

  # GET /shards/1
  # GET /shards/1.json
  def show
  end

  # GET /shards/new
  def new
    @shard = Shard.new
  end

  # GET /shards/1/edit
  def edit
  end

  # POST /shards
  # POST /shards.json
  def create
    @shard = Shard.new(shard_params)

    respond_to do |format|
      if @shard.save
        format.html { redirect_to @shard, notice: 'Shard was successfully created.' }
        format.json { render :show, status: :created, location: @shard }
      else
        format.html { render :new }
        format.json { render json: @shard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shards/1
  # PATCH/PUT /shards/1.json
  def update
    respond_to do |format|
      if @shard.update(shard_params)
        format.html { redirect_to @shard, notice: 'Shard was successfully updated.' }
        format.json { render :show, status: :ok, location: @shard }
      else
        format.html { render :edit }
        format.json { render json: @shard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shards/1
  # DELETE /shards/1.json
  def destroy
    @shard.destroy
    respond_to do |format|
      format.html { redirect_to shards_url, notice: 'Shard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shard
      @shard = Shard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shard_params
      params.require(:shard).permit(:rl_id, :role, :slots, :used_memory, :status, :db_id, :node_id)
    end
end
