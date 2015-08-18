class RelationshipsController < AuthenticatedController
  NO_FILE = 'Please select a file to upload!'

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1 || @page.blank?
    @relationships = Relationship.all.paginate(:page => @page, :per_page => 25)
  end

  def create
    if params[:import] == 'import'
      if params[:file].nil?
        flash[:notice] = self.class::NO_FILE
      else
        csv_text = File.read(params[:file].path)
        csv_text = csv_text.encode(Encoding.find('ASCII'), :invalid => :replace, :undef => :replace, :replace => '')
        csv = CSV.parse(csv_text, :headers => true)
        Relationship.import(csv)
      end
    end
    redirect_to relationships_path
  end
end
