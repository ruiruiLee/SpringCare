# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

target 'SpringCare' do
#正式版 经过测试后上线的稳定版本
#pod 'AVOSCloud'
#pod 'AVOSCloudSNS'

# ----测试版 可以随时更新最新版的SDK(但是不能保证稳定)----
# 因为beta版本更新不定时，所以改为使用线上最新的sdk
pod 'AVOSCloud', :podspec => 'https://download.avoscloud.com/sdk/iOS/current/AVOSCloud.podspec'
pod 'AVOSCloudSNS', :podspec => 'https://download.avoscloud.com/sdk/iOS/current/AVOSCloudSNS.podspec'

pod 'FMDB'
# pod 'FMDB/FTS'   # FMDB with FTS
# pod 'FMDB/standalone'   # FMDB with latest SQLite amalgamation source
# pod 'FMDB/standalone/FTS'   # FMDB with latest SQLite amalgamation source and FTS
# pod 'FMDB/SQLCipher'   # FMDB with SQLCipher

pod"AFNetworking","~>2.0"

end

target 'SpringCareTests' do

end

