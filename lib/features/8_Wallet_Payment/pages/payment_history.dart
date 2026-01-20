// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/bloc/wallet_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/2.wallet_ledger/wallet_ledger_model.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class PaymentHistoryPage extends StatefulWidget {
  WalletBloc bloc;
  PaymentHistoryPage({
    super.key,
    required this.bloc,
  });

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late WalletBloc bloc;

  @override
  void initState() {
    super.initState();
    // Gọi fetch history khi vào màn hình (nếu chưa có dữ liệu hoặc muốn refresh)
    // WalletBloc đã được truyền từ trang trước thông qua BlocProvider.value
    bloc = widget.bloc;
    if (bloc.state.transactions.isEmpty &&
        bloc.state.historyStatus != WalletStatus.loading) {
      bloc.add(WalletFetchHistoryEvent());
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('HH:mm - dd/MM/yyyy').format(date);
  }

  void _pickMonth() async {
    final DateTime currentSelected = bloc.state.selectedDate;

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return _MonthPickerDialog(initialDate: currentSelected);
      },
    );

    if (picked != null) {
      bloc.add(WalletChangeMonthEvent(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // Sử dụng BlocConsumer để lắng nghe sự kiện và rebuild UI từ Bloc được truyền vào
      body: BlocConsumer<WalletBloc, WalletState>(
        bloc: bloc,
        listener: (context, state) {
          if (state.historyStatus == WalletStatus.failure) {
            ShowSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          return Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B1F5A), kScaffoldBackground],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildMonthSelector(context, state, bloc),
                  Expanded(
                    child: _buildTransactionList(context, state, bloc),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthSelector(
      BuildContext context, WalletState state, WalletBloc bloc) {
    final String displayDate =
        "Tháng ${DateFormat('MM/yyyy').format(state.selectedDate)}";

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final newDate = DateTime(
                  state.selectedDate.year, state.selectedDate.month - 1);
              bloc.add(WalletChangeMonthEvent(newDate));
            },
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          GestureDetector(
            onTap: _pickMonth,
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: kNeonPink, size: 20),
                const SizedBox(width: 8),
                Text(
                  displayDate,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: (state.selectedDate.month == DateTime.now().month &&
                    state.selectedDate.year == DateTime.now().year)
                ? null
                : () {
                    final newDate = DateTime(
                        state.selectedDate.year, state.selectedDate.month + 1);
                    bloc.add(WalletChangeMonthEvent(newDate));
                  },
            icon: Icon(
              Icons.chevron_right,
              color: (state.selectedDate.month == DateTime.now().month &&
                      state.selectedDate.year == DateTime.now().year)
                  ? Colors.white24
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
      BuildContext context, WalletState state, WalletBloc bloc) {
    if (state.historyStatus == WalletStatus.loading) {
      return const Center(
          child: CircularProgressIndicator(color: kPrimaryPurple));
    }

    if (state.historyStatus == WalletStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: kErrorRed),
            const SizedBox(height: 16),
            Text(state.message, style: const TextStyle(color: Colors.white70)),
            TextButton(
                onPressed: () => bloc.add(WalletFetchHistoryEvent()),
                child: const Text("Thử lại"))
          ],
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long, size: 60, color: Colors.white24),
            SizedBox(height: 16),
            Text("Không có giao dịch nào trong tháng này",
                style: TextStyle(color: kHintColor)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final item = state.transactions[index];
        final trans = item.transaction;
        final bool isIncome = item.isIncome;
        final Color amountColor = isIncome ? kSuccessGreen : kErrorRed;
        final String sign = isIncome ? "+" : "-";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kBoxBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isIncome
                      ? kSuccessGreen.withOpacity(0.1)
                      : kErrorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: amountColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trans?.paymentTypeName ?? "Giao dịch",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(trans?.paymentCompleteAt),
                      style: const TextStyle(color: kHintColor, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trans?.statusName ?? "",
                      style: TextStyle(
                        color: (trans?.statusCode == "PAID")
                            ? kLinkActive
                            : Colors.orange,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$sign${_formatCurrency(item.changeAmount ?? 0)}",
                    style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "SD: ${_formatCurrency(item.newBalance ?? 0)}",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 11),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

// Widget Dialog Chọn Tháng (Không thay đổi logic, chỉ tái sử dụng)
class _MonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  const _MonthPickerDialog({required this.initialDate});
  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _currentYear;
  @override
  void initState() {
    super.initState();
    _currentYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kBoxBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() => _currentYear--),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Text(
                  "$_currentYear",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                  onPressed: () => setState(() => _currentYear++),
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final int month = index + 1;
                final bool isSelected =
                    _currentYear == widget.initialDate.year &&
                        month == widget.initialDate.month;
                final bool isFuture = _currentYear > DateTime.now().year ||
                    (_currentYear == DateTime.now().year &&
                        month > DateTime.now().month);
                return GestureDetector(
                  onTap: isFuture
                      ? null
                      : () => Navigator.of(context)
                          .pop(DateTime(_currentYear, month)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kPrimaryPurple
                          : (isFuture ? Colors.transparent : Colors.white10),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: kNeonPink)
                          : Border.all(color: Colors.transparent),
                    ),
                    alignment: Alignment.center,
                    child: Text("Thg $month",
                        style: TextStyle(
                          color: isFuture
                              ? Colors.white24
                              : (isSelected ? Colors.white : Colors.white70),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
