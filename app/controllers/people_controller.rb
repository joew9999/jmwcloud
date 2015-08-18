class PeopleController < AuthenticatedController
  NO_FILE = 'Please select a file to upload!'

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1 || @page.blank?
    @people = Person.order(:kbns).paginate(:page => @page, :per_page => 25)
  end

  def create
    if params[:import] == 'import'
      if params[:file].nil?
        flash[:notice] = self.class::NO_FILE
      else
        csv_text = File.read(params[:file].path)
        csv_text = csv_text.encode(Encoding.find('ASCII'), :invalid => :replace, :undef => :replace, :replace => '')
        csv = CSV.parse(csv_text, :headers => true)
        Person.import(csv)
      end
    end
    redirect_to people_path
  end
end
