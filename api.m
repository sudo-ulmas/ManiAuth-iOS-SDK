// Autogenerated from Pigeon (v20.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "api.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray<id> *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}

static FlutterError *createConnectionError(NSString *channelName) {
  return [FlutterError errorWithCode:@"channel-error" message:[NSString stringWithFormat:@"%@/%@/%@", @"Unable to establish connection on channel: '", channelName, @"'."] details:@""];
}

static id GetNullableObjectAtIndex(NSArray<id> *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@implementation ManiEnvironmentBox
- (instancetype)initWithValue:(ManiEnvironment)value {
  self = [super init];
  if (self) {
    _value = value;
  }
  return self;
}
@end

@implementation ManiResidentTypeBox
- (instancetype)initWithValue:(ManiResidentType)value {
  self = [super init];
  if (self) {
    _value = value;
  }
  return self;
}
@end

@interface Token ()
+ (Token *)fromList:(NSArray<id> *)list;
+ (nullable Token *)nullableFromList:(NSArray<id> *)list;
- (NSArray<id> *)toList;
@end

@interface HostInfo ()
+ (HostInfo *)fromList:(NSArray<id> *)list;
+ (nullable HostInfo *)nullableFromList:(NSArray<id> *)list;
- (NSArray<id> *)toList;
@end

@implementation Token
+ (instancetype)makeWithAccessToken:(nullable NSString *)accessToken
    refreshToken:(nullable NSString *)refreshToken {
  Token* pigeonResult = [[Token alloc] init];
  pigeonResult.accessToken = accessToken;
  pigeonResult.refreshToken = refreshToken;
  return pigeonResult;
}
+ (Token *)fromList:(NSArray<id> *)list {
  Token *pigeonResult = [[Token alloc] init];
  pigeonResult.accessToken = GetNullableObjectAtIndex(list, 0);
  pigeonResult.refreshToken = GetNullableObjectAtIndex(list, 1);
  return pigeonResult;
}
+ (nullable Token *)nullableFromList:(NSArray<id> *)list {
  return (list) ? [Token fromList:list] : nil;
}
- (NSArray<id> *)toList {
  return @[
    self.accessToken ?: [NSNull null],
    self.refreshToken ?: [NSNull null],
  ];
}
@end

@implementation HostInfo
+ (instancetype)makeWithPaymentSystemId:(nullable NSString *)paymentSystemId
    locale:(nullable NSString *)locale
    pinfl:(nullable NSString *)pinfl
    phoneNumber:(nullable NSString *)phoneNumber
    environment:(nullable ManiEnvironmentBox *)environment
    residentType:(nullable ManiResidentTypeBox *)residentType {
  HostInfo* pigeonResult = [[HostInfo alloc] init];
  pigeonResult.paymentSystemId = paymentSystemId;
  pigeonResult.locale = locale;
  pigeonResult.pinfl = pinfl;
  pigeonResult.phoneNumber = phoneNumber;
  pigeonResult.environment = environment;
  pigeonResult.residentType = residentType;
  return pigeonResult;
}
+ (HostInfo *)fromList:(NSArray<id> *)list {
  HostInfo *pigeonResult = [[HostInfo alloc] init];
  pigeonResult.paymentSystemId = GetNullableObjectAtIndex(list, 0);
  pigeonResult.locale = GetNullableObjectAtIndex(list, 1);
  pigeonResult.pinfl = GetNullableObjectAtIndex(list, 2);
  pigeonResult.phoneNumber = GetNullableObjectAtIndex(list, 3);
  pigeonResult.environment = GetNullableObjectAtIndex(list, 4);
  pigeonResult.residentType = GetNullableObjectAtIndex(list, 5);
  return pigeonResult;
}
+ (nullable HostInfo *)nullableFromList:(NSArray<id> *)list {
  return (list) ? [HostInfo fromList:list] : nil;
}
- (NSArray<id> *)toList {
  return @[
    self.paymentSystemId ?: [NSNull null],
    self.locale ?: [NSNull null],
    self.pinfl ?: [NSNull null],
    self.phoneNumber ?: [NSNull null],
    self.environment ?: [NSNull null],
    self.residentType ?: [NSNull null],
  ];
}
@end

@interface nullApiPigeonCodecReader : FlutterStandardReader
@end
@implementation nullApiPigeonCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 129: 
      return [Token fromList:[self readValue]];
    case 130: 
      return [HostInfo fromList:[self readValue]];
    case 131: 
      {
        NSNumber *enumAsNumber = [self readValue];
        return enumAsNumber == nil ? nil : [[ManiEnvironmentBox alloc] initWithValue:[enumAsNumber integerValue]];
      }
    case 132: 
      {
        NSNumber *enumAsNumber = [self readValue];
        return enumAsNumber == nil ? nil : [[ManiResidentTypeBox alloc] initWithValue:[enumAsNumber integerValue]];
      }
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface nullApiPigeonCodecWriter : FlutterStandardWriter
@end
@implementation nullApiPigeonCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[Token class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[HostInfo class]]) {
    [self writeByte:130];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[ManiEnvironmentBox class]]) {
    ManiEnvironmentBox * box = (ManiEnvironmentBox *)value;
    [self writeByte:131];
    [self writeValue:(value == nil ? [NSNull null] : [NSNumber numberWithInteger:box.value])];
  } else if ([value isKindOfClass:[ManiResidentTypeBox class]]) {
    ManiResidentTypeBox * box = (ManiResidentTypeBox *)value;
    [self writeByte:132];
    [self writeValue:(value == nil ? [NSNull null] : [NSNumber numberWithInteger:box.value])];
  } else {
    [super writeValue:value];
  }
}
@end

@interface nullApiPigeonCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation nullApiPigeonCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[nullApiPigeonCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[nullApiPigeonCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *nullGetApiCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    nullApiPigeonCodecReaderWriter *readerWriter = [[nullApiPigeonCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}
@interface ManiAuthApi ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@property(nonatomic, strong) NSString *messageChannelSuffix;
@end

@implementation ManiAuthApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  return [self initWithBinaryMessenger:binaryMessenger messageChannelSuffix:@""];
}
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger messageChannelSuffix:(nullable NSString*)messageChannelSuffix{
  self = [self init];
  if (self) {
    _binaryMessenger = binaryMessenger;
    _messageChannelSuffix = [messageChannelSuffix length] == 0 ? @"" : [NSString stringWithFormat: @".%@", messageChannelSuffix];
  }
  return self;
}
- (void)sendHostInfo:(HostInfo *)arg_hostInfo completion:(void (^)(FlutterError *_Nullable))completion {
  NSString *channelName = [NSString stringWithFormat:@"%@%@", @"dev.flutter.pigeon.mani_auth.ManiAuthApi.send", _messageChannelSuffix];
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:channelName
      binaryMessenger:self.binaryMessenger
      codec:nullGetApiCodec()];
  [channel sendMessage:@[arg_hostInfo ?: [NSNull null]] reply:^(NSArray<id> *reply) {
    if (reply != nil) {
      if (reply.count > 1) {
        completion([FlutterError errorWithCode:reply[0] message:reply[1] details:reply[2]]);
      } else {
        completion(nil);
      }
    } else {
      completion(createConnectionError(channelName));
    } 
  }];
}
@end

void SetUpHostAppApi(id<FlutterBinaryMessenger> binaryMessenger, NSObject<HostAppApi> *api) {
  SetUpHostAppApiWithSuffix(binaryMessenger, api, @"");
}

void SetUpHostAppApiWithSuffix(id<FlutterBinaryMessenger> binaryMessenger, NSObject<HostAppApi> *api, NSString *messageChannelSuffix) {
  messageChannelSuffix = messageChannelSuffix.length > 0 ? [NSString stringWithFormat: @".%@", messageChannelSuffix] : @"";
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:[NSString stringWithFormat:@"%@%@", @"dev.flutter.pigeon.mani_auth.HostAppApi.cancel", messageChannelSuffix]
        binaryMessenger:binaryMessenger
        codec:nullGetApiCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(cancelWithError:)], @"HostAppApi api (%@) doesn't respond to @selector(cancelWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api cancelWithError:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:[NSString stringWithFormat:@"%@%@", @"dev.flutter.pigeon.mani_auth.HostAppApi.authSuccess", messageChannelSuffix]
        binaryMessenger:binaryMessenger
        codec:nullGetApiCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(authSuccessToken:error:)], @"HostAppApi api (%@) doesn't respond to @selector(authSuccessToken:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray<id> *args = message;
        Token *arg_token = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api authSuccessToken:arg_token error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
