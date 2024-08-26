/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool _isLoading = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupsAddMemberSuccessState) {
          Navigator.of(context).pop();
          showMessageDialog(
            context,
            title: 'Sucesso',
            message: 'Membro adicionado ao grupo.',
            type: AlertType.success,
            onRedirect: () {},
          );
        } else if (state is GroupsErrorState) {
          Navigator.of(context).pop();
          showMessageDialog(
            context,
            title: 'Ops...',
            message: state.message,
            type: AlertType.error,
            onConfirm: () {},
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'PRISM QR',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          toolbarHeight: 80,
        ),
        body: Stack(
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          final data = result!.code;
          if (data != null) {
            final parts = data.split('|');
            if (parts.length == 2) {
              final groupId = parts[0];
              final ownerId = parts[1];
              _addMemberToGroup(groupId, ownerId);
            } else {
              _showError('QR Code inválido.');
            }
          } else {
            _showError('Código escaneado inválido.');
          }
        }
      });
    });
  }

  void _addMemberToGroup(String groupId, String ownerId) {
    final userId = context.read<UserCubit>().state.id;

    setState(() {
      _isLoading = true;
    });

    context.read<GroupsBloc>().add(GroupsAddMemberEvent(
      userId: ownerId,
      id: groupId,
      user: userId,
    ));
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
