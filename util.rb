def uncommitted_changes?
  false
end

def aaep_client
  Aws::S3::Client.new(credentials: fetch_credentials!)
end

def fetch_credentials!
  Aws::SharedCredentials.new(profile_name: ENV['TF_VAR_profile'])
end

def aaep_tf_bucket
  s3 = Aws::S3::Resource.new(client: aaep_client)
  s3.bucket('aaep-terraform-state')
end
