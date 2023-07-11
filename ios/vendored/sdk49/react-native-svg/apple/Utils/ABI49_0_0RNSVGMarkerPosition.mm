
#import "ABI49_0_0RNSVGMarkerPosition.h"

@implementation ABI49_0_0RNSVGMarkerPosition
- (instancetype)init
{
  self = [super init];
  if (self) {
    _type = kStartMarker;
    _origin = ABI49_0_0RNSVGZEROPOINT;
    _angle = 0;
  }
  return self;
}

+ (instancetype)markerPosition:(ABI49_0_0RNSVGMarkerType)type origin:(CGPoint)origin angle:(float)angle
{
  ABI49_0_0RNSVGMarkerPosition *newElement = [[self alloc] init];
  newElement.type = type;
  newElement.origin = origin;
  newElement.angle = angle;
  return newElement;
}

+ (NSArray<ABI49_0_0RNSVGMarkerPosition *> *)fromCGPath:(CGPathRef)path
{
  ABI49_0_0positions_ = [[NSMutableArray alloc] init];
  ABI49_0_0element_index_ = 0;
  ABI49_0_0origin_ = ABI49_0_0RNSVGZEROPOINT;
  ABI49_0_0subpath_start_ = ABI49_0_0RNSVGZEROPOINT;
  CGPathApply(path, (__bridge void *)ABI49_0_0positions_, ABI49_0_0UpdateFromPathElement);
  ABI49_0_0PathIsDone();
  return ABI49_0_0positions_;
}

void ABI49_0_0PathIsDone()
{
  float angle = ABI49_0_0CurrentAngle(kEndMarker);
  [ABI49_0_0positions_ addObject:[ABI49_0_0RNSVGMarkerPosition markerPosition:kEndMarker origin:ABI49_0_0origin_ angle:angle]];
}

static double BisectingAngle(double in_angle, double out_angle)
{
  // WK193015: Prevent bugs due to angles being non-continuous.
  if (fabs(in_angle - out_angle) > 180)
    in_angle += 360;
  return (in_angle + out_angle) / 2;
}

static CGFloat ABI49_0_0RNSVG_radToDeg = 180 / (CGFloat)M_PI;

double ABI49_0_0rad2deg(CGFloat rad)
{
  return rad * ABI49_0_0RNSVG_radToDeg;
}

CGFloat ABI49_0_0SlopeAngleRadians(CGSize p)
{
  CGFloat angle = atan2(p.height, p.width);
  return angle;
}

double ABI49_0_0CurrentAngle(ABI49_0_0RNSVGMarkerType type)
{
  // For details of this calculation, see:
  // http://www.w3.org/TR/SVG/single-page.html#painting-MarkerElement
  double in_angle = ABI49_0_0rad2deg(ABI49_0_0SlopeAngleRadians(ABI49_0_0in_slope_));
  double out_angle = ABI49_0_0rad2deg(ABI49_0_0SlopeAngleRadians(ABI49_0_0out_slope_));
  switch (type) {
    case kStartMarker:
      if (ABI49_0_0auto_start_reverse_)
        out_angle += 180;
      return out_angle;
    case kMidMarker:
      return BisectingAngle(in_angle, out_angle);
    case kEndMarker:
      return in_angle;
  }
  return 0;
}

typedef struct SegmentData {
  CGSize start_tangent; // Tangent in the start point of the segment.
  CGSize end_tangent; // Tangent in the end point of the segment.
  CGPoint position; // The end point of the segment.
} SegmentData;

CGSize ABI49_0_0subtract(CGPoint *p1, CGPoint *p2)
{
  return CGSizeMake(p2->x - p1->x, p2->y - p1->y);
}

static void ComputeQuadTangents(SegmentData *data, CGPoint *start, CGPoint *control, CGPoint *end)
{
  data->start_tangent = ABI49_0_0subtract(control, start);
  data->end_tangent = ABI49_0_0subtract(end, control);
  if (CGSizeEqualToSize(CGSizeZero, data->start_tangent))
    data->start_tangent = data->end_tangent;
  else if (CGSizeEqualToSize(CGSizeZero, data->end_tangent))
    data->end_tangent = data->start_tangent;
}

SegmentData ABI49_0_0ExtractPathElementFeatures(const CGPathElement *element)
{
  SegmentData data;
  CGPoint *points = element->points;
  switch (element->type) {
    case kCGPathElementAddCurveToPoint:
      data.position = points[2];
      data.start_tangent = ABI49_0_0subtract(&points[0], &ABI49_0_0origin_);
      data.end_tangent = ABI49_0_0subtract(&points[2], &points[1]);
      if (CGSizeEqualToSize(CGSizeZero, data.start_tangent))
        ComputeQuadTangents(&data, &points[0], &points[1], &points[2]);
      else if (CGSizeEqualToSize(CGSizeZero, data.end_tangent))
        ComputeQuadTangents(&data, &ABI49_0_0origin_, &points[0], &points[1]);
      break;
    case kCGPathElementAddQuadCurveToPoint:
      data.position = points[1];
      ComputeQuadTangents(&data, &ABI49_0_0origin_, &points[0], &points[1]);
      break;
    case kCGPathElementMoveToPoint:
    case kCGPathElementAddLineToPoint:
      data.position = points[0];
      data.start_tangent = ABI49_0_0subtract(&data.position, &ABI49_0_0origin_);
      data.end_tangent = ABI49_0_0subtract(&data.position, &ABI49_0_0origin_);
      break;
    case kCGPathElementCloseSubpath:
      data.position = ABI49_0_0subpath_start_;
      data.start_tangent = ABI49_0_0subtract(&data.position, &ABI49_0_0origin_);
      data.end_tangent = ABI49_0_0subtract(&data.position, &ABI49_0_0origin_);
      break;
  }
  return data;
}

void ABI49_0_0UpdateFromPathElement(void *info, const CGPathElement *element)
{
  SegmentData segment_data = ABI49_0_0ExtractPathElementFeatures(element);
  // First update the outgoing slope for the previous element.
  ABI49_0_0out_slope_ = segment_data.start_tangent;
  // Record the marker for the previous element.
  if (ABI49_0_0element_index_ > 0) {
    ABI49_0_0RNSVGMarkerType marker_type = ABI49_0_0element_index_ == 1 ? kStartMarker : kMidMarker;
    float angle = ABI49_0_0CurrentAngle(marker_type);
    [ABI49_0_0positions_ addObject:[ABI49_0_0RNSVGMarkerPosition markerPosition:marker_type origin:ABI49_0_0origin_ angle:angle]];
  }
  // Update the incoming slope for this marker position.
  ABI49_0_0in_slope_ = segment_data.end_tangent;
  // Update marker position.
  ABI49_0_0origin_ = segment_data.position;
  // If this is a 'move to' segment, save the point for use with 'close'.
  if (element->type == kCGPathElementMoveToPoint)
    ABI49_0_0subpath_start_ = element->points[0];
  else if (element->type == kCGPathElementCloseSubpath)
    ABI49_0_0subpath_start_ = CGPointZero;
  ++ABI49_0_0element_index_;
}

NSMutableArray<ABI49_0_0RNSVGMarkerPosition *> *ABI49_0_0positions_;
unsigned ABI49_0_0element_index_;
CGPoint ABI49_0_0origin_;
CGPoint ABI49_0_0subpath_start_;
CGSize ABI49_0_0in_slope_;
CGSize ABI49_0_0out_slope_;
bool ABI49_0_0auto_start_reverse_;

@end
