class DbsController < ApplicationController
  before_action :set_db, only: [:show, :edit, :update, :destroy]

  # GET /dbs
  # GET /dbs.json
  def index
    @dbs = []
    if params[:cluster_id]
      @dbs = Db.all.includes(:cluster).where(cluster_id: params[:cluster_id])
    elsif params[:node_id]
      dbs_in_node = Shard.where(node_id: params[:node_id]).map{|s| s.db_id}.uniq
      @dbs = Db.includes(:cluster).find(dbs_in_node)
    elsif params[:crdt_guid]
      # geo-distributed dbs
      @dbs = Db.all.includes(:cluster).where(crdt_guid: params[:crdt_guid])
    elsif params[:neighbors_of]
      # dbs having master shards in same nodes as
      #  the master shards of db specified in params[:neighbors_of]
      db_id = params[:neighbors_of]
      db_node_ids = Shard.where(db_id: db_id, role: 'master').map{|s| s.node_id}.uniq
      dbs_in_same_nodes = Shard.where(node_id: db_node_ids, role: 'master').map{|s| s.db_id}.uniq
      @dbs = Db.includes(:cluster).find(dbs_in_same_nodes)
    elsif params[:filter]
      if params[:filter].empty?
        @dbs = Db.all.includes(:cluster)
      else
        f = params[:filter].strip
        @dbs = Db.where("name LIKE :f OR endpoint_host LIKE :f", f: "%#{f}%").includes(:cluster)
      end
    end
    @dbs = @dbs.sort_by { |d| d.name }
  end

  # GET /dbs/1
  # GET /dbs/1.json
  def show
  end

  # GET /dbs/new
  def new
    @db = Db.new
  end

  # GET /dbs/1/edit
  def edit
  end

  # POST /dbs
  # POST /dbs.json
  def create
    @db = Db.new(db_params)

    respond_to do |format|
      if @db.save
        format.html { redirect_to @db, notice: 'Db was successfully created.' }
        format.json { render :show, status: :created, location: @db }
      else
        format.html { render :new }
        format.json { render json: @db.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dbs/1
  # PATCH/PUT /dbs/1.json
  def update
    respond_to do |format|
      if @db.update(db_params)
        format.html { redirect_to @db, notice: 'Db was successfully updated.' }
        format.json { render :show, status: :ok, location: @db }
      else
        format.html { render :edit }
        format.json { render json: @db.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dbs/1
  # DELETE /dbs/1.json
  def destroy
    @db.destroy
    respond_to do |format|
      format.html { redirect_to dbs_url, notice: 'Db was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_db
      @db = Db.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def db_params
      params.require(:db).permit(:rl_id, :name, :engine, :status, :num_shards, :placement, :replication, :persistence, :endpoint_host, :endpoint_port, :cluster_id, :proxy_policy, :crdt_guid, :sync, :resque_web, :eviction_policy, :engine_version, :memory_limit)
    end
end
