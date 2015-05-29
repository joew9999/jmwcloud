class ImagesController < AuthenticatedController
  def create
    Image.create(image_params)
  end

  private
    def image_params
      params.require(:image).permit(:image, :type)
    end
end