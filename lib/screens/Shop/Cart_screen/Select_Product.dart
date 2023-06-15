import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myteam/model/productsModel.dart';
import 'package:myteam/screens/Shop/Cart_screen/Checkout_Product.dart';

class SelectProduct extends StatefulWidget {
  List<AllProductsModel> productDetails;
  SelectProduct({this.productDetails});
  @override
  _SelectProductState createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50, left: 10),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.productDetails[0].image,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                child: (Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: Text(
                              widget.productDetails[0].title,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Price: ${widget.productDetails[0].salePrice} \$',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 2.4 / 2,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: CircleAvatar(
                                        radius: 62,
                                        backgroundColor: Colors.red,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey[200],
                                          child: Text(
                                            'M',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: ExpandableText(
                        ' ${widget.productDetails[0].description}'),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.only(bottom: 25),
                    child: CustomButton('Proceed To Checkout', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CheckoutProduct()),
                      );
                    }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 2,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.red;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... Read more" : " Read less",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
