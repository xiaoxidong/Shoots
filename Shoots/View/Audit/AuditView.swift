//
//  AuditView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/20.
//

import SwiftUI

struct AuditView: View {
    @StateObject var auditVM: AuditPicsViewModel = AuditPicsViewModel()
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            Group {
                if !auditVM.auditFeed.isEmpty {
                    CardStack(direction: LeftRight.direction, data: auditVM.auditFeed, onSwipe: { audit, direction in
                        if direction == .right {
                            // 审核通过
                            Task {
                                await self.auditVM.verify(audit: audit, code: .success) { _ in }
                            }
                        } else {
                            // 审核失败
                            Task {
                                await self.auditVM.verify(audit: audit, code: .fail) { _ in }
                            }
                        }
                    }, content: { audit, direction, isOnTop in
                        AuditCardView(audit: audit, direction: direction)
                    })
                } else {
                    if auditVM.loading {
                        LoadingView()
                            .onAppear {
                                Task {
                                    await auditVM.getFirstPageFeed()
                                }
                            }
                    } else {
                        VStack(spacing: 26) {
                            ShootEmptyView(text: "没有需要审核的内容")
                            Button {
                                Task {
                                    await auditVM.getFirstPageFeed()
                                }
                            } label: {
                                Text("刷新")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.vertical, 8)
                                    .frame(width: 166)
                                    .foregroundColor(Color.white)
                                    .background(Color.shootRed)
                                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                    .contentShape(Rectangle())
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("审核内容")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if let last = auditVM.lastAuditPic {
                            Task {
                                await auditVM.verify(audit: last, code: .none) { success in
                                    if success {
                                        auditVM.auditFeed.insert(last, at: 0)
                                        auditVM.lastAuditPic = nil
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                    }.disabled(auditVM.lastAuditPic == nil)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        AuditView()
    }
}
