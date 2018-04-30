module EmailHelper
  def email_image_tag(image, **options)
    #attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    attachments.inline[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  def email_s3image_tag(image_url, **options)
    #attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    #attachments.inline[image_url] = File.read("https://s3.amazonaws.com/tkbtestbucket/#{image_url}")
    attachments.inline[image_url] = image_tag("https://s3.amazonaws.com/tgcloudtestbucket/companies/avatars/000/000/002/original/connect.jpg")
    image_tag attachments[image_url].url, **options
  end
end