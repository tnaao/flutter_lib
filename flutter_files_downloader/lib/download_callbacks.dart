///[fileName] the output file name that will be stored in downloads directory
///[progress] the download progress
typedef OnProgress = Function(String? fileName, double progress);

///[path] the output file absolute path
typedef OnDownloadCompleted = Function(String path);

///[errorMessage] if download did not succeed for some reason, errorMessage will contains the failure reason
///e.g. the url is not correct [404] or the file is not accessible [400]
typedef OnDownloadError = Function(String errorMessage);

///The download callbacks 'container'
class DownloadCallbacks {
  final OnProgress? onProgress;
  final OnDownloadCompleted? onDownloadCompleted;
  final OnDownloadError? onDownloadError;

  DownloadCallbacks({
    this.onProgress,
    this.onDownloadCompleted,
    this.onDownloadError,
  });

  @override
  String toString() {
    return 'DownloadCallbacks{onProgress: $onProgress, onDownloadCompleted: $onDownloadCompleted, onDownloadError: $onDownloadError}';
  }
}
