class PeopleController < AuthenticatedController
  NO_FILE = "Please select a file to upload!"

  def index
    @people = Person.all.paginate(page: 1, per_page: 25)
  end

  def create
    if params[:import] == 'import'
      if params[:file].nil?
        flash[:notice] = self.class::NO_FILE
      else
        csv_text = File.read(params[:file].path)
        csv_text = csv_text.encode(Encoding.find('ASCII'), {invalid: :replace, undef: :replace, replace: ''})
        csv = CSV.parse(csv_text, headers: true)
        people = Person::import(csv)
      end
    else
      #Save regularly
    end
    redirect_to people_path
  end
end