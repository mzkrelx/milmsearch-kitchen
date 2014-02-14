elasticsearch_dir = "/usr/share/elasticsearch"
head_path = "mobz/elasticsearch-head"

execute "install elasticsearch-head" do
  command "#{elasticsearch_dir}/bin/plugin -install #{head_path}"
end
