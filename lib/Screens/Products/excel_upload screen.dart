import 'dart:io';
import 'package:excel/excel.dart' as e;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../GlobalComponents/Model/category_model.dart';
import '../../currency.dart';
import '../../subscription.dart';

class ExcelUploader extends StatefulWidget {
  const ExcelUploader({super.key, required this.previousProductName, required this.previousProductCode});

  final List<String> previousProductName;
  final List<String> previousProductCode;

  @override
  State<ExcelUploader> createState() => _ExcelUploaderState();
}

class _ExcelUploaderState extends State<ExcelUploader> {
  List<String> allCategory = [];
  List<String> allNameInThisFile = [];
  List<String> allCodeInThisFile = [];
  // List<String> allBrand = [];
  // List<String> allUnit = [];
  String? filePat;
  File? file;
  String getFileExtension(String fileName) {
    return fileName.split('/').last;
  }
  Future<void> downloadAndOpenFile(String fileName) async {
    final storage = FirebaseStorage.instance;

    try {
      // String downloadUrl = await FirebaseStorage.instance
      //     .ref('path/to/your/excel/file.xlsx')
      //     .getDownloadURL();

      // return downloadUrl;
      final ref = storage.ref('gs://pos-saas-a7b6c.appspot.com/POS_SAAS_bulk_product_upload.xlsx');
      final bytes = await ref.getData();

      final tempDirectory = await getTemporaryDirectory();
      final filePath = '${tempDirectory.path}/$fileName';

      await File(filePath).writeAsBytes(bytes!);

      await OpenFile.open(filePath,);
      // launch(downloadUrl);
    } catch (error) {
      print(error); // Handle any errors
    }
  }

  // Future<void> downloadFile() async {
  //   final storage = FirebaseStorage.instance;
  //   final ref = storage.ref('gs://pos-saas-a7b6c.appspot.com/POS_SAAS_bulk_product_upload.xlsx');
  //   try {
  //     final url = await ref.getDownloadURL();
  //     final anchor = html.AnchorElement(href: url);
  //     anchor.download = 'excel_file.xlsx';
  //     html.document.body?.children.add(anchor);
  //     anchor.click();
  //     anchor.remove();
  //   } catch (error) {
  //     print(error); // Handle any errors
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Uploader'),
      ),
      body: Consumer(builder: (context, ref, __) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: file != null,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Card(
                        child: ListTile(
                            leading: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Image(image: AssetImage('images/excel.png'))),
                            title: Text(
                              getFileExtension(file?.path ?? ''),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                                child: const Text('Remove')))),
                  ),
                ),
                Visibility(
                  visible: file == null,
                  child: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Image(
                        height: 100,
                        width: 100,
                        image: AssetImage('images/file-upload.png'),
                      )),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(kMainColor)),
                  onPressed: () async {
                    if (file == null) {
                      await pickAndUploadFile(ref: ref);
                    } else {
                      EasyLoading.show(status: 'Uploading...');
                      await uploadProducts(ref: ref, file: file!, context: context);
                    }
                  },
                  child: Text(file == null ? 'Pick and Upload File' : 'Upload', style: const TextStyle(color: Colors.white)),
                ),
                TextButton(onPressed: () async =>await downloadAndOpenFile('excel_file.xlsx'), child: const Text('Download Excel Format')),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> pickAndUploadFile({required WidgetRef ref}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }

    // if (result != null) {
    //   file = File(result.files.single.path!);
    //
    // }
  }

  Future<void> uploadProducts({
    required File file,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var excel = e.Excel.createExcel();
    excel = e.Excel.decodeBytes(await file.readAsBytes());

    var sheet = excel.sheets.keys.first;
    var table = excel.tables[sheet]!;

    for (var row in table.rows) {
      ProductModel? data = createProductModelFromExcelData(row: row, ref: ref);
      if (data != null) {
        final DatabaseReference productInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Products');
        productInformationRef.keepSynced(true);
        productInformationRef.push().set(data.toJson());
        Subscription.decreaseSubscriptionLimits(itemType: 'products', context: null);
      }
    }
    ref.refresh(productProvider);
    ref.refresh(categoryProvider);

    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.showSuccess('Upload Done');
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    });
  }

  ProductModel? createProductModelFromExcelData({required List<e.Data?> row, required WidgetRef ref}) {
    bool isProductNameUnique({required String? productName}) {
      for (var name in widget.previousProductName) {
        if (name.toLowerCase().trim() == productName?.trim().toLowerCase()) {
          return false;
        }
      }
      for (var element in allNameInThisFile) {
        if (element.toLowerCase().trim() == productName?.trim().toLowerCase()) {
          return false;
        }
      }

      productName != null ? allNameInThisFile.add(productName) : null;

      return true;
    }

    bool isProductCodeUnique({required String? productCode}) {
      for (var name in widget.previousProductCode) {
        if (name.toLowerCase().trim() == productCode?.trim().toLowerCase()) {
          return false;
        }
      }
      for (var element in allCodeInThisFile) {
        if (element.toLowerCase().trim() == productCode?.trim().toLowerCase()) {
          return false;
        }
      }

      productCode != null ? allCodeInThisFile.add(productCode) : null;

      return true;
    }

    String getCategoryFromDatabase({required WidgetRef ref, required String givenCategoryName}) {
      final categoryData = ref.watch(categoryProvider);
      categoryData.when(
        data: (categories) {
          bool pos = true;
          for (var element in categories) {
            if (element.categoryName.toLowerCase().trim() == givenCategoryName.toLowerCase().trim()) {
              pos = false;
              break;
            }
          }
          for (var element in allCategory) {
            if (element.toLowerCase().trim() == givenCategoryName.toLowerCase().trim()) {
              pos = false;
              break;
            }
          }
          pos ? addCategory(categoryName: givenCategoryName) : null;
          allCategory.add(givenCategoryName.trim().toLowerCase());

          return givenCategoryName;
        },
        error: (error, stackTrace) {},
        loading: () {},
      );
      return givenCategoryName;
    }

    List<String> getSerialNumbers(String? serialNumberString) {
      List<String> data = serialNumberString?.split(",") ?? [];
      List<String> data2 = [];
      for (var element in data) {
        data2.add(element.removeAllWhiteSpace().trim());
      }
      return data2;
    }

    ProductModel productModel = ProductModel(
      productName: '',
      productCategory: '',
      size: '',
      color: '',
      weight: '',
      capacity: '',
      type: '',
      brandName: '',
      productCode: '',
      productStock: '',
      productUnit: '',
      productSalePrice: '',
      productPurchasePrice: '',
      productDiscount: '',
      productWholeSalePrice: '',
      productDealerPrice: '',
      productManufacturer: '',
      warehouseName: '',
      warehouseId: '',
      productPicture:
          'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f',
      serialNumber: [],
      lowerStockAlert: 0,
    );
    for (var element in row) {
      if (element?.rowIndex == 0) {
        return null;
      }
      switch (element?.columnIndex) {
        case 1:
          if (element?.value == null || !isProductNameUnique(productName: element?.value.toString())) return null;
          productModel.productName = element?.value.toString() ?? '';
          break;
        case 2:
          if (element?.value == null || !isProductCodeUnique(productCode: element?.value.toString())) return null;
          productModel.productCode = element?.value.toString() ?? '';
          break;
        case 3:
          if (element?.value == null && num.tryParse(element?.value.toString() ?? '') != null) return null;
          productModel.productStock = element?.value.toString() ?? '';
          break;
        case 5:
          if (element?.value == null && num.tryParse(element?.value.toString() ?? '') != null) return null;
          productModel.productSalePrice = element?.value.toString() ?? '';
          break;
        case 4:
          if (element?.value == null && num.tryParse(element?.value.toString() ?? '') != null) return null;
          productModel.productPurchasePrice = element?.value.toString() ?? '';
          break;
        case 6:
          element?.value != null ? productModel.productWholeSalePrice = element!.value.toString() : null;
          break;
        case 7:
          element?.value != null ? productModel.productDealerPrice = element!.value.toString() : null;
          break;
        case 8:
          if (element?.value == null) return null;
          productModel.productCategory = getCategoryFromDatabase(ref: ref, givenCategoryName: element!.value.toString());
          break;
        case 9:
          // productModel.brandName = getBrandsFromDatabase(ref: ref, givenBrandName: element?.value.toString()) ?? '';
          element?.value != null ? productModel.brandName = element!.value.toString() : null;
          break;
        case 10:
          // productModel.productUnit = getUnitFromDatabase(ref: ref, givenUnitName: element?.value.toString()) ?? '';
          element?.value != null ? productModel.productUnit = element!.value.toString() : null;
          break;
        case 11:
          element?.value != null ? productModel.productManufacturer = element!.value.toString() : null;
          break;
        case 12:
          element?.value != null ? productModel.manufacturingDate = element?.value.toString() : null;
          break;
        case 13:
          element?.value != null ? productModel.expiringDate = element?.value.toString() : null;
          break;
        case 14:
          productModel.lowerStockAlert = int.tryParse(element?.value.toString() ?? '') ?? 0;
          break;
        case 15:
          element?.value != null ? productModel.serialNumber = getSerialNumbers(element?.value.toString()) : null;
          break;
      }
    }
    return productModel;
  }

  void addCategory({required String categoryName}) {
    final DatabaseReference categoryInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Categories');
    categoryInformationRef.keepSynced(true);
    CategoryModel categoryModel = CategoryModel(
      categoryName: categoryName,
      size: false,
      color: false,
      capacity: false,
      type: false,
      weight: false,
      warranty: false,
    );
    categoryInformationRef.push().set(categoryModel.toJson());
  }

  // String? getBrandsFromDatabase({required WidgetRef ref, required String? givenBrandName}) {
  //   if (givenBrandName != null) {
  //     final brandsData = ref.watch(brandsProvider);
  //     brandsData.when(
  //       data: (brands) {
  //         bool pos = true;
  //         for (var element in brands) {
  //           if (element.brandName.toLowerCase().trim() == givenBrandName.toLowerCase().trim()) {
  //             pos = false;
  //             break;
  //           }
  //         }
  //         for (var element in allBrand) {
  //           if (element.toLowerCase().trim() == givenBrandName.toLowerCase().trim()) {
  //             pos = false;
  //             break;
  //           }
  //         }
  //         pos ? addBrands(brandName: givenBrandName) : null;
  //         allBrand.add(givenBrandName.trim().toLowerCase());
  //
  //         return givenBrandName;
  //       },
  //       error: (error, stackTrace) {},
  //       loading: () {},
  //     );
  //     return givenBrandName;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // void addBrands({required String brandName}) {
  //   final DatabaseReference brandRef = FirebaseDatabase.instance.ref().child(constUserId).child('Brands');
  //   brandRef.keepSynced(true);
  //   BrandsModel brand = BrandsModel(brandName);
  //   brandRef.push().set(brand.toJson());
  // }

  // String? getUnitFromDatabase({required WidgetRef ref, required String? givenUnitName}) {
  //   if (givenUnitName != null) {
  //     final unitData = ref.watch(unitsProvider);
  //     unitData.when(
  //       data: (units) {
  //         bool pos = true;
  //         for (var element in units) {
  //           if (element.unitName.toLowerCase().trim() == givenUnitName.toLowerCase().trim()) {
  //             pos = false;
  //             break;
  //           }
  //         }
  //         for (var element in allUnit) {
  //           if (element.toLowerCase().trim() == givenUnitName.toLowerCase().trim()) {
  //             pos = false;
  //             break;
  //           }
  //         }
  //         pos ? addUnit(unitName: givenUnitName) : null;
  //         allUnit.add(givenUnitName.trim().toLowerCase());
  //
  //         return givenUnitName;
  //       },
  //       error: (error, stackTrace) {},
  //       loading: () {},
  //     );
  //     return givenUnitName;
  //   } else {
  //     return null;
  //   }
  // }

  // void addUnit({required String unitName}) {
  //   final DatabaseReference unitRepo = FirebaseDatabase.instance.ref().child(constUserId).child('Units');
  //   unitRepo.keepSynced(true);
  //   UnitModel unit = UnitModel(unitName);
  //   unitRepo.push().set(unit.toJson());
  // }
}
